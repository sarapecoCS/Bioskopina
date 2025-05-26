using System;
using System.IO;

namespace Bioskopina.Services.Helpers
{
    public static class ImageHelper
    {
        public static byte[] ConvertImageToByteArray(string imageFileName)
        {
            // Explicit path to UserPicture folder
            string userPictureFolder = @"C:\Users\WIN10\Documents\B\backend\Bioskopina\UserPicture"; // Absolute path
            string fullImagePath = Path.Combine(userPictureFolder, imageFileName);

            // Log the generated full path
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
