import firebase_admin
from firebase_admin import credentials, firestore
import json
import os
from dotenv import load_dotenv

# carrega o .env
load_dotenv(dotenv_path=r'C:\CineTrack_Web\Bot\.env')

# pega a chave de serviço 
account_key = os.getenv("ACCOUNT_KEY")

try: 
    # inicializa o Firebase com a chave de serviço 
    cred = credentials.Certificate(account_key)
    firebase_admin.initialize_app(cred)
    # cria um cliente para acessar o Firebase
    # db será usado para ler e gravar dados
    db = firestore.client()
except Exception as e:
    print(f"Falha ao conectar com Firebase.\nErro: {e}")

# carrega os filmes do JSON
with open(r"C:\CineTrack_Web\Bot\filmes.json", "r", encoding="utf-8") as f:
    filmes = json.load(f)

try:
    for filme in filmes:
        # cria uma referência a um novo documento na coleção movies
        # o document() sem argumentos gera um ID aleatório para o documento
        doc_ref = db.collection('movies').document()
        # set(filme) salva o filme na coleção
        doc_ref.set(filme)
except Exception as e:
    print(f"Erro ao importar filme.\nErro: {e}")
    
print("Importação finalizada!")
