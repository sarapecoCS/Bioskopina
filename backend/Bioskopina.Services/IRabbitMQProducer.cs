using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Bioskopina.Services
{
    public interface IRabbitMQProducer
    {
        public void SendMessage<T>(T message);
    }
}