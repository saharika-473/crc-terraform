import unittest
import requests

class TestLambdaIntegration(unittest.TestCase):
    def setUp(self):
        self.endpoint_url = 'https://4ix1ubxo38.execute-api.us-east-1.amazonaws.com/prod/countVisitor'

    def test_api_gateway_integration(self):
        response = requests.get(self.endpoint_url)
        self.assertEqual(response.status_code, 200)
        # Add more assertions to validate response content if needed

    def test_cors_configuration(self):
        headers = {
            'Origin': 'https://aws.rahulpatel.com',  # Replace with your actual origin
        }
        response = requests.get(self.endpoint_url, headers=headers)
        self.assertEqual(response.status_code, 200)
        # Add more assertions to validate CORS headers if needed

if __name__ == '__main__':
    unittest.main()
