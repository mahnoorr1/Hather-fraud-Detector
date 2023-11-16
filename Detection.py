from flask import Flask, request, jsonify
from tensorflow.keras.models import load_model
from tensorflow.keras.preprocessing.text import Tokenizer
from tensorflow.keras.preprocessing.sequence import pad_sequences
import pickle  # Import the 'pickle' module

app = Flask(__name__)

# Load the saved model
model = load_model('spam_detection_model.h5')
print('model loaded')

# Load the tokenizer with the same configuration as in Colab
with open('tokenizer.pickle', 'rb') as handle:
    tokenizer = pickle.load(handle)
print('tokenizating...')

# Define preprocessing hyperparameters
max_len = 50
padding_type = "post"
trunc_type = "post"


@app.route('/', methods=['GET'])
def home():
    return "Server is running"


@app.route('/modelpredict', methods=['POST'])
def modelpredict():
    # Get the 'input' parameter from the request query
    input_text = request.args.get('input')

    # Preprocess the input text the same way as in Colab
    input_sequences = tokenizer.texts_to_sequences([input_text])
    input_data = pad_sequences(
        input_sequences, maxlen=max_len, padding=padding_type, truncating=trunc_type)
    print(input_data)

    # Make a prediction using the model
    prediction = model.predict(input_data)

    raw_prediction = prediction[0][0]
    print(raw_prediction)

    # Adjust the threshold as needed
    threshold = 0.8
    prediction_result = "Invalid" if raw_prediction > threshold else "Valid"

    response_data = {
        "input": input_text,
        "prediction_result": prediction_result,
        "prediction": float(raw_prediction)
    }

    print(float(raw_prediction))

    # Prepare a JSON response with the prediction result
    resp = jsonify(response_data)
    resp.status_code = 200
    resp.headers.add("Access-Control-Allow-Origin", "*")

    return resp


if __name__ == '__main__':
    # Run the Flask application
    app.run(debug=True, port=13000, use_reloader=False, host='0.0.0.0')
