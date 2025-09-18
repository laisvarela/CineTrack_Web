import time
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.firefox.service import Service
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.firefox.options import Options

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
    lista = driver.find_elements(By.TAG_NAME, "ul")
    for item in lista:
        item.find_element(By.TAG_NAME, "li")
        if item.get_attribute("class"):
            div_principal = item.find_element(By.CSS_SELECTOR, ".card.entity-card.entity-card-list.cf")
            div_secundaria = div_principal.find_element(By.CLASS_NAME, "meta")
            titulo = div_secundaria.find_element(By.TAG_NAME, "h2").text
            div_corpo = div_secundaria.find_elements(By.CLASS_NAME, "meta-body")
            for div in div_corpo:
                div.find_element(By.TAG_NAME, "span")
                if div.get_attribute("class") == "Director":
                    return
            
    return

if __name__ == "__main__":
    crawler()