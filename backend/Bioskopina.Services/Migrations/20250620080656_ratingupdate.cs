using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class ratingupdate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 1,
                column: "Score",
                value: 9m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 2,
                column: "Score",
                value: 3m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 3,
                column: "Score",
                value: 8m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 4,
                column: "Score",
                value: 1m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 9,
                column: "Score",
                value: 10m);

            migrationBuilder.UpdateData(
                table: "Rating",
                keyColumn: "ID",
                keyValue: 2,
                column: "RatingValue",
                value: 8);

            migrationBuilder.InsertData(
                table: "Rating",
                columns: new[] { "ID", "DateAdded", "MovieID", "RatingValue", "ReviewText", "UserID" },
                values: new object[] { 6, new DateTime(2025, 7, 21, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 10, "I think it is just perfect. The way tragedy can have such a deep roots it just unforgetable.", 3 });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Rating",
                keyColumn: "ID",
                keyValue: 6);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 1,
                column: "Score",
                value: 0m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 2,
                column: "Score",
                value: 0m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 3,
                column: "Score",
                value: 0m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 4,
                column: "Score",
                value: 0m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 9,
                column: "Score",
                value: 0m);

            migrationBuilder.UpdateData(
                table: "Rating",
                keyColumn: "ID",
                keyValue: 2,
                column: "RatingValue",
                value: 9);
        }
    }
}
