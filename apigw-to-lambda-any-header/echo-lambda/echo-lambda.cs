using System.Net;
using System.Text.Json;
using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;

[assembly: LambdaSerializer(typeof(Amazon.Lambda.Serialization.SystemTextJson.DefaultLambdaJsonSerializer))]

namespace EchoLambda;

public class Function
{
  public async Task<APIGatewayProxyResponse> FunctionHandler(APIGatewayProxyRequest request, ILambdaContext context)
  {
    return await Task.FromResult(new APIGatewayProxyResponse()
    {
      StatusCode = (int)HttpStatusCode.OK,
      IsBase64Encoded = false,
      Body = JsonSerializer.Serialize(request)
    });
  }
}