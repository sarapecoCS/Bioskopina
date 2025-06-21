using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class bioskopinalistseed : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "BioskopinaList",
                columns: new[] { "ID", "ListID", "MovieID" },
                values: new object[,]
                {
                    { 1, 1, 1 },
                    { 2, 1, 2 },
                    { 3, 1, 3 },
                    { 4, 2, 4 },
                    { 5, 2, 5 },
                    { 6, 2, 6 },
                    { 7, 3, 7 },
                    { 8, 3, 8 },
                    { 9, 3, 9 },
                    { 10, 4, 1 },
                    { 11, 4, 3 },
                    { 12, 4, 5 },
                    { 13, 4, 7 },
                    { 14, 5, 2 },
                    { 15, 5, 4 },
                    { 16, 5, 6 },
                    { 17, 5, 8 },
                    { 18, 4, 9 },
                    { 19, 2, 9 }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "BioskopinaList",
                keyColumn: "ID",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "BioskopinaList",
                keyColumn: "ID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "BioskopinaList",
                keyColumn: "ID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "BioskopinaList",
                keyColumn: "ID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "BioskopinaList",
                keyColumn: "ID",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "BioskopinaList",
                keyColumn: "ID",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "BioskopinaList",
                keyColumn: "ID",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "BioskopinaList",
                keyColumn: "ID",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "BioskopinaList",
                keyColumn: "ID",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "BioskopinaList",
                keyColumn: "ID",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "BioskopinaList",
                keyColumn: "ID",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "BioskopinaList",
                keyColumn: "ID",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "BioskopinaList",
                keyColumn: "ID",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "BioskopinaList",
                keyColumn: "ID",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "BioskopinaList",
                keyColumn: "ID",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "BioskopinaList",
                keyColumn: "ID",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "BioskopinaList",
                keyColumn: "ID",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "BioskopinaList",
                keyColumn: "ID",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "BioskopinaList",
                keyColumn: "ID",
                keyValue: 19);
        }
    }
}
