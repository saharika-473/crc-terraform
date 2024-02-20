import unittest
from unittest.mock import patch, MagicMock
from ...visit_counter import lambda_handler

class TestLambdaUnit(unittest.TestCase):

    @patch('lambda_function.visit_counter.get_item')
    @patch('lambda_function.visit_counter.update_item')
    @patch('lambda_function.ip_table.get_item')
    @patch('lambda_function.ip_table.update_item')
    def test_unique_visitor_count_update(self, mock_update_ip, mock_get_ip, mock_update_count, mock_get_count):
        # Mock the DynamoDB responses
        mock_get_count.return_value = {'Item': {'visitor_count': 10}}
        mock_get_ip.return_value = {'Item': None}

        # Invoke the Lambda function
        event = {'requestContext': {'identity': {'sourceIp': '192.168.1.1'}}}
        lambda_handler(event, None)

        # Check if update_item was called for visitor count
        mock_update_count.assert_called_once()

    @patch('lambda_function.visit_counter.get_item')
    @patch('lambda_function.visit_counter.update_item')
    @patch('lambda_function.ip_table.get_item')
    @patch('lambda_function.ip_table.update_item')
    def test_last_visit_time_update(self, mock_update_ip, mock_get_ip, mock_update_count, mock_get_count):
        # Mock the DynamoDB responses
        mock_get_count.return_value = {'Item': {'visitor_count': 10}}
        mock_get_ip.return_value = {'Item': None}

        # Invoke the Lambda function
        event = {'requestContext': {'identity': {'sourceIp': '192.168.1.1'}}}
        lambda_handler(event, None)

        # Check if update_item was called for IP address table
        mock_update_ip.assert_called_once()

    @patch('lambda_function.visit_counter.get_item')
    @patch('lambda_function.visit_counter.update_item')
    @patch('lambda_function.ip_table.get_item')
    @patch('lambda_function.ip_table.update_item')
    def test_fetching_visitor_count(self, mock_update_ip, mock_get_ip, mock_update_count, mock_get_count):
        # Mock the DynamoDB response for visitor count
        mock_get_count.return_value = {'Item': {'visitor_count': 10}}

        # Invoke the Lambda function
        response = lambda_handler({}, None)

        # Check if response contains the correct visitor count
        self.assertEqual(response['statusCode'], 200)
        self.assertEqual(response['body'], '{"message": "Unique Visitor Count Updated", "visitor_count": 10}')

    # Write similar test methods for error handling scenarios
    # Error Handling - Visitor Count Fetch
    # Error Handling - Unique Visitor Check
    # Error Handling - Visitor Count Update
    # Error Handling - Last Visit Time Update
        
    @patch('lambda_function.visit_counter.get_item')
    @patch('lambda_function.visit_counter.update_item')
    @patch('lambda_function.ip_table.get_item')
    @patch('lambda_function.ip_table.update_item')
    def test_visitor_count_fetch_error_handling(self, mock_update_ip, mock_get_ip, mock_update_count, mock_get_count):
        # Mock an error scenario where fetching visitor count fails
        mock_get_count.side_effect = Exception("Error fetching visitor count")

        # Invoke the Lambda function
        response = lambda_handler({}, None)

        # Check if the response indicates the failure to fetch visitor count
        self.assertEqual(response['statusCode'], 500)
        # Add more assertions to check the response content if needed

    @patch('lambda_function.visit_counter.get_item')
    @patch('lambda_function.visit_counter.update_item')
    @patch('lambda_function.ip_table.get_item')
    @patch('lambda_function.ip_table.update_item')
    def test_unique_visitor_check_error_handling(self, mock_update_ip, mock_get_ip, mock_update_count, mock_get_count):
        # Mock an error scenario where checking for unique visitor fails
        mock_get_ip.side_effect = Exception("Error checking unique visitor")

        # Invoke the Lambda function
        response = lambda_handler({'requestContext': {'identity': {'sourceIp': '192.168.1.1'}}}, None)

        # Check if the response indicates the failure to check for unique visitor
        self.assertEqual(response['statusCode'], 500)
        # Add more assertions to check the response content if needed

    @patch('lambda_function.visit_counter.get_item')
    @patch('lambda_function.visit_counter.update_item')
    @patch('lambda_function.ip_table.get_item')
    @patch('lambda_function.ip_table.update_item')
    def test_visitor_count_update_error_handling(self, mock_update_ip, mock_get_ip, mock_update_count, mock_get_count):
        # Mock an error scenario where updating visitor count fails
        mock_update_count.side_effect = Exception("Error updating visitor count")

        # Invoke the Lambda function
        response = lambda_handler({}, None)

        # Check if the response indicates the failure to update visitor count
        self.assertEqual(response['statusCode'], 500)
        # Add more assertions to check the response content if needed

    @patch('lambda_function.visit_counter.get_item')
    @patch('lambda_function.visit_counter.update_item')
    @patch('lambda_function.ip_table.get_item')
    @patch('lambda_function.ip_table.update_item')
    def test_last_visit_time_update_error_handling(self, mock_update_ip, mock_get_ip, mock_update_count, mock_get_count):
        # Mock an error scenario where updating last visit time fails
        mock_update_ip.side_effect = Exception("Error updating last visit time")

        # Invoke the Lambda function
        response = lambda_handler({'requestContext': {'identity': {'sourceIp': '192.168.1.1'}}}, None)

        # Check if the response indicates the failure to update last visit time
        self.assertEqual(response['statusCode'], 500)
        # Add more assertions to check the response content if needed

if __name__ == '__main__':
    unittest.main()