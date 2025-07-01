using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class bioskopipnaupdate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Q&A",
                keyColumn: "ID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Q&A",
                keyColumn: "ID",
                keyValue: 5);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 5,
                column: "Score",
                value: 4m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 7,
                column: "Score",
                value: 5m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 8,
                column: "Score",
                value: 6m);

            migrationBuilder.UpdateData(
                table: "Donation",
                keyColumn: "ID",
                keyValue: 1,
                column: "Amount",
                value: 2m);

            migrationBuilder.InsertData(
                table: "Rating",
                columns: new[] { "ID", "DateAdded", "MovieID", "RatingValue", "ReviewText", "UserID" },
                values: new object[,]
                {
                    { 7, new DateTime(2025, 7, 21, 0, 0, 0, 0, DateTimeKind.Unspecified), 5, 4, "Jimmy is just briliant but it's slightly sad movie", 5 },
                    { 8, new DateTime(2025, 7, 21, 0, 0, 0, 0, DateTimeKind.Unspecified), 6, 5, "WW2 theme is good.", 5 }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Rating",
                keyColumn: "ID",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Rating",
                keyColumn: "ID",
                keyValue: 8);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 5,
                column: "Score",
                value: 0m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 7,
                column: "Score",
                value: 0m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 8,
                column: "Score",
                value: 0m);

            migrationBuilder.UpdateData(
                table: "Donation",
                keyColumn: "ID",
                keyValue: 1,
                column: "Amount",
                value: 20m);

            migrationBuilder.InsertData(
                table: "Q&A",
                columns: new[] { "ID", "Answer", "CategoryID", "Displayed", "Question", "UserID" },
                values: new object[,]
                {
                    { 3, "Do not worry! We will be keeping design.", 3, true, "Do not make design more modern please.", 5 },
                    { 5, "At least 7 months.", 1, true, "How long did it take you to make this app?", 4 }
                });
        }
    }
}
