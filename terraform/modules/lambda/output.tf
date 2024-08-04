output "get_lambda_function_output"{
    value = aws_lambda_function.showMuseum
}
output "delete_lambda_function_output"{
    value = aws_lambda_function.deleteMuseum
}
output "post_lambda_function_output"{
    value = aws_lambda_function.addMuseum
}
output "put_lambda_function_output"{
    value = aws_lambda_function.updateMuseum
}