from flask import Flask, render_template

app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html')  # página inicial

@app.route('/denuncia')
def denuncia():
    return render_template('denuncia.html')

@app.route('/reclamacao')
def reclamacao():
    return render_template('reclamacao.html')

@app.route('/acompanhamento')
def acompanhamento():
    return render_template('acompanhamento.html')

@app.route("/ajuda")
def ajuda():
    return render_template('ajuda.html')


if __name__ == '__main__':
    app.run(debug=True)
