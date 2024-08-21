from flask import Flask, jsonify, request
import requests

app = Flask(__name__)

@app.route('/data', methods=['GET'])
def get_data():
    # Call App2 to get data
    response = requests.get('http://app2.default.svc.cluster.local/data')
    data_from_app2 = response.json()
    return jsonify({"app1_data": "Hello from App1", "app2_data": data_from_app2})

@app.route('/extra', methods=['GET'])
def get_extra():
    return jsonify({"app1_extra_data": "This is additional data from App1"})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
