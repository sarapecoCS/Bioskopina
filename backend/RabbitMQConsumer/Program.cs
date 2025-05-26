using RabbitMQ.Client;
using RabbitMQ.Client.Events;
using RabbitMQConsumer;
using System.Text;

public class Program
{
    public static void Main(string[] args)
    {
        var factory = new ConnectionFactory
        {
            HostName = Environment.GetEnvironmentVariable("RABBITMQ_HOST") ?? "",
            Port = int.Parse(Environment.GetEnvironmentVariable("RABBITMQ_PORT") ?? ""),
            UserName = Environment.GetEnvironmentVariable("RABBITMQ_USERNAME") ?? "",
            Password = Environment.GetEnvironmentVariable("RABBITMQ_PASSWORD") ?? "",
            RequestedConnectionTimeout = TimeSpan.FromSeconds(30),
            RequestedHeartbeat = TimeSpan.FromSeconds(60),
            AutomaticRecoveryEnabled = true,
            NetworkRecoveryInterval = TimeSpan.FromSeconds(10),
        };

        factory.ClientProvidedName = "Rabbit Test Consumer";

        try
        {
            Console.WriteLine($"Connecting to RabbitMQ at {factory.HostName}:{factory.Port} with user {factory.UserName}");
            using (var connection = factory.CreateConnection())
            using (var channel = connection.CreateModel())
            {
                Console.WriteLine("Connected to RabbitMQ successfully.");

                string exchangeName = "EmailExchange";
                string routingKey = "email_queue";
                string queueName = "EmailQueue";

                channel.ExchangeDeclare(exchangeName, ExchangeType.Direct);
                channel.QueueDeclare(queueName, true, false, false, null);
                channel.QueueBind(queueName, exchangeName, routingKey, null);

                var consumer = new EventingBasicConsumer(channel);

                consumer.Received += (sender, args) =>
                {
                    var body = args.Body.ToArray();
                    string message = Encoding.UTF8.GetString(body);

                    Console.WriteLine($"Message received: {message}");
                    EmailService emailService = new EmailService();
                    emailService.SendEmail(message);

                    channel.BasicAck(args.DeliveryTag, false);
                };

                channel.BasicConsume(queueName, false, consumer);

                Console.WriteLine("Waiting for messages. Press Q to quit.");

                // Sleep for a long time to keep the application running
                Thread.Sleep(Timeout.Infinite);

                // Close resources before exiting
                channel.Close();
                connection.Close();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Connection to RabbitMQ failed: {ex.Message}");
            Console.WriteLine(ex.ToString());
        }
    }
}