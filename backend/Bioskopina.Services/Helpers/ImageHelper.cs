using System;
using System.IO;

namespace Bioskopina.Services.Helpers
{
    public static class ImageHelper
    {
        public static byte[] ConvertImageToByteArray(string relativeImagePath)
        {

            string baseDir = AppContext.BaseDirectory;


            string fullImagePath = Path.Combine(baseDir, relativeImagePath);

            Console.WriteLine("Generated Full Image Path: " + fullImagePath);

            if (File.Exists(fullImagePath))
            {
                return File.ReadAllBytes(fullImagePath);
            }
            else
            {
                Console.WriteLine("File not found at: " + fullImagePath);
                throw new FileNotFoundException($"Image not found at: {fullImagePath}");
            }
        }



    }
}
