import flask
from flask import request, jsonify, send_file
import os

app = flask.Flask(__name__)


@app.route('/', methods=['GET'])
def home():
    print("yasssss")
    return "yasssss"

def process_audio():
    os.system('demucs --two-stems vocals audio.mp3')

@app.route('/separate', methods=['POST'])
def spleeter_GET():
    print("executing")
    # if no audio file send error back
    if 'audio' not in request.files:
        return jsonify({'error': 'No audio file found'})

    # obtain audio file from request and save it to a file
    audio_file = request.files['audio']
    audio_path = 'audio.mp3'
    audio_file.save(audio_path)

    process_audio()

    #delete audio.wav
    os.remove('./audio.mp3')

    # Return prediction as JSON
    return send_file('separated/htdemucs/audio/no_vocals.wav', as_attachment=True)

if __name__ == '__main__':
    app.run(port=5000, debug=False, host='0.0.0.0')

    