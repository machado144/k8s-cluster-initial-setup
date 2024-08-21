from flask import Flask, jsonify, request
import requests

app = Flask(__name__)

@app.route('/data', methods=['GET'])
def get_data():
    # Call App1 to get additional data
    response = requests.get('http://app1.default.svc.cluster.local/extra')
    extra_data_from_app1 = response.json()
    return jsonify({"app3_data": "Hello from App3", "app1_extra_data": extra_data_from_app1})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
