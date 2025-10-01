import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.firefox.service import Service
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.firefox.options import Options
import re
import json
options = Options()
options.binary_location = r"C:\Program Files\Mozilla Firefox\firefox.exe"
geckodriver_path = r"C:\CineTrack_Web\Bot\geckodriver.exe"
service = Service(executable_path=geckodriver_path)
ublock_path = r"C:\CineTrack_Web\Bot\ublock_origin-1.66.0.xpi"
driver = webdriver.Firefox(service=service, options=options)
driver.install_addon(ublock_path, temporary=True)

filmes = []

def crawler():
    # abre o driver na página 
    driver.get("https://www.adorocinema.com/filmes/numero-cinemas/")
    
    # faz o scraping do primeiro link
    scraper("https://www.adorocinema.com/filmes/numero-cinemas/")
    try:
        # até a página 10 do site
        for i in range(1, 10):
            # espera até que o elemento que contém o link para próxima página carregue completamente
            # senão causa erro pois o driver está tentando acessar um componente que não existe ainda
            WebDriverWait(driver, 30).until(EC.presence_of_element_located((By.TAG_NAME, "nav")))
            
            # encontra o elemento através do class, quando há só uma classe, usa By.CLASS_NAME
            # quando o class é um conjunto de classes, é utilizado o CSS_SELECTOR, seprando cada classe com um .
            elemento = driver.find_element(By.CSS_SELECTOR, ".pagination.cf")
            
            # manualmente eu executo um script para fechar qualquer janela de cookie que esteja bloqueando meu acesso
            driver.execute_script("""
                    var el = document.getElementById('js-cookie-info');
                    if (el) { el.parentNode.removeChild(el); }
            """)
            # e aguardo meio segundo para assegurar a ação
            time.sleep(0.5)

            # novamente aguardo até que o elemento exista antes de acessar
            botao_prox = WebDriverWait(driver, 10).until(
                EC.element_to_be_clickable((By.CSS_SELECTOR, ".button.button-md.button-primary-full.button-right"))
            )
            # se botão conter o atributo href, indica que é o botão de próxima página que procuro
            if botao_prox.get_attribute("href"):
                link = botao_prox.get_attribute("href")
                # faço o scraping no link, se a função me retornar true, o scraping foi um sucesso e o botão para próxima página pode ser clicado
                if scraper(link):
                    url_antes = driver.current_url
                    botao_prox.click()
                    WebDriverWait(driver, 30).until(EC.url_changes(url_antes))
                else: 
                    print(f"Scraper falhou para {link}")
                    break
    except Exception as e:
        print(f"Não foi possível clicar na próxima página. Erro: {e}")

def scraper(link):
    titulo = None
    ano = 0
    sinopse = None
    direcao = []
    generos = []
    url_capa = None
    try:
        # os filmes estão dentro de uma lista no site, então eu aguardo até que toda tag li do site seja carregada completamente
        WebDriverWait(driver, 30).until(EC.presence_of_element_located((By.TAG_NAME, "li")))
        
        # encontro a lista pela tag
        lista = driver.find_elements(By.TAG_NAME, "li")
        
            
            # para cada item da lista, eu procuro pela class que contém as informações que busco: titulo, gênero, direção, sinopse, ano e imagem
        for item in lista:
            if item.get_attribute("class"):
                    # explicação desse bloco try:
                    # quando eu recebo todos os elementos com tag <li> do site, nem todos vão ter a class que eu procuro,
                    # o que me retorna um erro. Para contornar essa situação, se disparar uma exceção, o código apenas continua 
                    # até que eventualmente vai encontrar o elemento certo.
                try:
                    WebDriverWait(driver, 30).until(EC.presence_of_element_located((By.CSS_SELECTOR, ".card.entity-card.entity-card-list.cf")))
                    div_principal = item.find_element(By.CSS_SELECTOR, ".card.entity-card.entity-card-list.cf")
                except:
                    continue
                try:
                        # com exceção da imagem, todas as informações estão disponíveis no texto da div
                    linhas = div_principal.text.split("\n")
                    if linhas and len(linhas) >= 2:
                            # o título sempre fica na posição 0 depois do split
                        titulo = ' '.join(linhas[0].split())
                            
                            # o ano e genêro ficam na mesma linha [1], mas separados por um |
                        partes = [p.strip() for p in linhas[1].split("|")]
                        if len(partes) >= 3:
                                # eu desejo pegar apenas o ano do filme, antão aplico um regex
                            match = re.search(r"\b\d{4}\b", partes[0])
                            ano = match.group(0) if match else None
                            generos = ', '.join([g.strip() for g in partes[2].split(",")])
                        else:
                            ano = 0
                            generos = []
                                
                        direcao = []
                            # Procura pela linha de direção, que sempre fica na posição linha [2]
                        if linhas[2].lower().startswith("direção:"):
                            direcao = ', '.join([d.strip() for d in linhas[2].replace("Direção:", "").split(",")])
                            
                            # já a sinopse não tem posição certa, mas é a linha com mais caracteres
                        if len(linhas) > 1:
                            # Ignora o título (linhas[0]) e pega a maior das demais
                            sinopse = max(linhas[1:], key=len).replace(',', '')
                        else:
                            sinopse = "Sem sinopse."
                            
                except Exception as e:
                        print(f"Falha no scraping. Erro {e}")
                    
                    # tentar pegar a imagem de capa
                try:
                    img_tag = div_principal.find_element(By.TAG_NAME, "img")
                    url = img_tag.get_attribute("src")
                    if '.jpg' in url:
                        url_capa = url
                    else:
                        url_capa = ""
                except Exception as e:
                    print(f"Falha na captura de imagem.\nErro: {e}")
                    url_capa = ""
                
                filme = {
                        "titulo": titulo,
                        "ano": ano,
                        "genero": generos,
                        "direcao": direcao,
                        "sinopse": sinopse,
                        "capa": url_capa
                }
                
                if not any(f["titulo"].lower() == filme["titulo"].lower() for f in filmes):
                    filmes.append(filme)
                  
    except Exception as e:
        print(f"Falha ao encontrar elementos na página. Erro: {e}")
        return False
    return True

if __name__ == "__main__":
    crawler()
    try:
        with open(r"C:\CineTrack_Web\Bot\filmes.json", "a", encoding="utf-8") as f:
            json.dump(filmes, f, ensure_ascii=False, indent=2)
    except Exception as e:
        print(f"Falha ao salvar filmes no arquivo json.\nErro: {e}")
    
    print("Scraping completo!")
    