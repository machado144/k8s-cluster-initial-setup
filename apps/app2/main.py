from flask import Flask, jsonify, request
import requests

app = Flask(__name__)

@app.route('/data', methods=['GET'])
def get_data():
    # Call App3 to get data
    response = requests.get('http://app3.default.svc.cluster.local/data')
    data_from_app3 = response.json()
    return jsonify({"app2_data": "Hello from App2", "app3_data": data_from_app3})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
