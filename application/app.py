from flask import Flask, jsonify, Response
import time
import math
import os
import threading

app = Flask(__name__)

# Global variable to simulate CPU load
cpu_load_enabled = False

@app.route('/')
def hello():
    return jsonify({
        "message": "Hello, World!",
        "version": "1.0.0",
        "pod_name": os.getenv('HOSTNAME', 'unknown')
    })

@app.route('/health')
def health():
    return jsonify({"status": "healthy"})

@app.route('/metrics')
def metrics():
    """Simple metrics endpoint for Prometheus"""
    cpu_usage = "high" if cpu_load_enabled else "low"
    return Response(f"""# HELP app_requests_total Total number of requests
# TYPE app_requests_total counter
app_requests_total{{endpoint="/"}} 1000
app_requests_total{{endpoint="/health"}} 500
# HELP app_cpu_usage CPU usage level
# TYPE app_cpu_usage gauge
app_cpu_usage {{level="{cpu_usage}"}} 1
""", mimetype='text/plain')

@app.route('/cpu-load')
def cpu_load():
    """Endpoint to simulate CPU load"""
    global cpu_load_enabled
    cpu_load_enabled = True
    
    # Simulate CPU intensive work
    def intensive_calculation():
        for _ in range(1000000):
            math.factorial(100)
    
    # Run in thread to avoid blocking
    thread = threading.Thread(target=intensive_calculation)
    thread.start()
    
    return jsonify({
        "message": "CPU load simulation started",
        "status": "high_cpu"
    })

@app.route('/cpu-normal')
def cpu_normal():
    """Endpoint to stop CPU load simulation"""
    global cpu_load_enabled
    cpu_load_enabled = False
    return jsonify({
        "message": "CPU load simulation stopped",
        "status": "normal"
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=False)