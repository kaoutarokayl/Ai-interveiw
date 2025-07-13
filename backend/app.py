from flask import Flask, jsonify, request
from flask_cors import CORS
import requests
import traceback
import random

app = Flask(__name__)
CORS(app)  # Autorise toutes les origines pour test local

# Questions simulées
questions = [
    "Pouvez-vous expliquer la différence entre let, const et var en JavaScript ?",
    "Qu'est-ce qu'une API RESTful, et comment en concevriez-vous une ?",
    "Comment gérez-vous les erreurs dans le code asynchrone en Python ?",
    "Quelle est la différence entre les bases de données SQL et NoSQL ?",
    "Pouvez-vous décrire le modèle d'architecture MVC ?",
]

@app.route('/ask', methods=['GET'])
def ask_question():
    domain = request.args.get('domain', 'web')  # tu peux passer ?domain=web ou data ou mobile
    prompt = f"""
Génère une question d'entretien technique pour un poste de développeur junior dans le domaine {domain}.
La question doit être claire, concise et adaptée à un niveau débutant.
Réponds uniquement par la question, sans explication ni réponse.
"""
    try:
        response = requests.post(
            "http://localhost:11434/api/generate",
            json={"model": "tinyllama", "prompt": prompt, "stream": False},
            timeout=60
        )
        result = response.json()
        print("✅ Question générée par Ollama :", result)
        question = result.get("response", "").strip() or "Aucune question générée."
        return jsonify({"response": question})
    except Exception as e:
        print(f"Erreur lors de la génération de la question : {e}")
        traceback.print_exc()
        return jsonify({"error": "Erreur lors de la génération de la question."}), 500


@app.route('/analyze', methods=['POST'])
def analyze_answer():
    try:
        data = request.get_json()
        print("📨 Données reçues du client Flutter :", data)

        if not data or 'question' not in data or 'answer' not in data:
            return jsonify({"error": "Champs manquants : 'question' et 'answer' sont requis."}), 400

        question = data['question']
        user_answer = data['answer']

        system_prompt = """
Tu es un coach expert en entretiens techniques pour des postes de développeur junior.
Ton rôle est de fournir une analyse constructive, bienveillante et détaillée de la réponse d'un utilisateur à une question d'entretien.
Réponds toujours en français, même si la question est en anglais.

Format de réponse :
1. **Évaluation Générale**
2. **Points Forts**
3. **Axes d'Amélioration**
4. **Réponse Idéale**
        """

        prompt = f"{system_prompt}\n\nQuestion : \"{question}\"\nRéponse de l'utilisateur : \"{user_answer}\""

        response = requests.post(
            "http://localhost:11434/api/generate",
            json={"model": "tinyllama", "prompt": prompt, "stream": False},
            timeout=60
        )

        response.raise_for_status()
        result = response.json()

        print("✅ Réponse brute d'Ollama :", result)

        answer = result.get("response", "").strip() or "Aucune réponse générée."
        return jsonify({"response": answer})

    except requests.exceptions.RequestException as e:
        print(f"🔴 Erreur de requête Ollama : {e}")
        traceback.print_exc()
        return jsonify({"error": f"Connexion à Ollama échouée : {str(e)}"}), 500
    except Exception as e:
        print(f"🔴 Erreur générale : {e}")
        traceback.print_exc()
        return jsonify({"error": "Erreur interne lors de l'analyse."}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
