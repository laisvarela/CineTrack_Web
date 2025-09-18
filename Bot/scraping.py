import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.firefox.service import Service
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.firefox.options import Options
import re
options = Options()
options.binary_location = r"C:\Program Files\Mozilla Firefox\firefox.exe"
geckodriver_path = r"C:\CineTrack_Web\Bot\geckodriver.exe"
service = Service(executable_path=geckodriver_path)
ublock_path = r"C:\CineTrack_Web\Bot\ublock_origin-1.66.0.xpi"
driver = webdriver.Firefox(service=service, options=options)
driver.install_addon(ublock_path, temporary=True)

def crawler():
    # abre o driver na página 
    driver.get("https://www.adorocinema.com/filmes/numero-cinemas/")
    
    links = []
    links.append("https://www.adorocinema.com/filmes/numero-cinemas/")
    scraper(links[0])
    try:
        for i in range(1, 10):
            scraper(links[i-1])
            WebDriverWait(driver, 30).until(EC.presence_of_element_located((By.TAG_NAME, "nav")))
            elemento = driver.find_element(By.CSS_SELECTOR, ".pagination.cf")
            driver.execute_script("""
                    var el = document.getElementById('js-cookie-info');
                    if (el) { el.parentNode.removeChild(el); }
            """)
            time.sleep(0.5)
            botao_prox = WebDriverWait(driver, 10).until(
                EC.element_to_be_clickable((By.CSS_SELECTOR, ".button.button-md.button-primary-full.button-right"))
            )
            if botao_prox.get_attribute("href"):
                link = botao_prox.get_attribute("href")
                links.append(link)
                if scraper(link):
                    url_antes = driver.current_url
                    botao_prox.click()
                    WebDriverWait(driver, 30).until(EC.url_changes(url_antes))
                else: 
                    print(f"Scraper falhou para {link}")
                    break
    except Exception as e:
        print(f"Não foi possível clicar na próxima página. Erro: {e}")
    return links

def scraper(link):
    titulo = None
    ano = 0
    sinopse = None
    direcao = []
    generos = []
    url_capa = None
    try:
        WebDriverWait(driver, 30).until(EC.presence_of_element_located((By.TAG_NAME, "li")))
        lista = driver.find_elements(By.TAG_NAME, "li")
        with open(r"C:\CineTrack_Web\Bot\filmes.txt", "r", encoding="utf-8") as read:
            titulos = set()
            for linha in read:
                if linha.startswith("Título:"):
                    titulo = linha.replace("Título: ", "").replace("\n", "")
                    titulos.add(titulo)
                    
        with open(r"C:\CineTrack_Web\Bot\filmes.txt", "a", encoding="utf-8") as f:
            for item in lista:
                if item.get_attribute("class"):
                    try:
                        WebDriverWait(driver, 30).until(EC.presence_of_element_located((By.CSS_SELECTOR, ".card.entity-card.entity-card-list.cf")))
                        div_principal = item.find_element(By.CSS_SELECTOR, ".card.entity-card.entity-card-list.cf")
                    except:
                        continue
                    try:
                        linhas = div_principal.text.split("\n")
                        if linhas and len(linhas) >= 2:
                            titulo = ' '.join(linhas[0].split())
                            partes = [p.strip() for p in linhas[1].split("|")]
                            if len(partes) >= 3:
                                match = re.search(r"\b\d{4}\b", partes[0])
                                ano = match.group(0) if match else None
                                generos = ', '.join([g.strip() for g in partes[2].split(",")])
                            else:
                                ano = 0
                                generos = []
                                # Procura pela linha de direção
                            direcao = []
                            
                            if linhas[2].lower().startswith("direção:"):
                                direcao = ', '.join([d.strip() for d in linhas[2].replace("Direção:", "").split(",")])
                            
                            
                            if len(linhas) > 1:
                                # Ignora o título (linhas[0]) e pega a maior das demais
                                sinopse = max(linhas[1:], key=len).replace(',', '')
                            else:
                                sinopse = "Sem sinopse."

                            if titulo not in titulos:
                                try:
                                    f.write(f"Título: {titulo}\nAno: {ano}\nGênero: {generos}\nDireção: {direcao}\nSinopse: {sinopse}\n\n")
                                    titulos.add(titulo.replace("\n", ""))
                                except Exception as e: 
                                    print(f"Erro ao salvar filme. Erro: {e}")
                                    continue
                            
                    except Exception as e:
                        print(f"Falha no scraping. Erro {e}")
                        
    except Exception as e:
        print(f"Falha ao encontrar elementos na página. Erro: {e}")
        return False
    return True

if __name__ == "__main__":
    crawler()