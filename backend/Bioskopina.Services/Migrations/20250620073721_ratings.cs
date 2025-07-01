using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class ratings : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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
                keyValue: 5,
                column: "Score",
                value: 0m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 6,
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
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 9,
                column: "Score",
                value: 0m);

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "DislikesCount", "UserID" },
                values: new object[] { 4, 2 });

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 3,
                column: "UserID",
                value: 2);

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 4,
                column: "UserID",
                value: 4);

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 5,
                columns: new[] { "DislikesCount", "LikesCount" },
                values: new object[] { 3, 0 });

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 7,
                column: "UserID",
                value: 4);

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 8,
                column: "UserID",
                value: 2);

            migrationBuilder.UpdateData(
                table: "Rating",
                keyColumn: "ID",
                keyValue: 3,
                columns: new[] { "MovieID", "UserID" },
                values: new object[] { 1, 3 });

            migrationBuilder.UpdateData(
                table: "Rating",
                keyColumn: "ID",
                keyValue: 4,
                column: "MovieID",
                value: 4);

            migrationBuilder.InsertData(
                table: "Rating",
                columns: new[] { "ID", "DateAdded", "MovieID", "RatingValue", "ReviewText", "UserID" },
                values: new object[] { 5, new DateTime(2025, 7, 21, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, 1, "It is quite slow to be honest, not my cup of tea.", 2 });

            migrationBuilder.UpdateData(
                table: "User",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "Email", "FirstName", "LastName" },
                values: new object[] { "korisnik@edu.fit.ba", "Korisnik", "Korisnik" });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Rating",
                keyColumn: "ID",
                keyValue: 5);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 1,
                column: "Score",
                value: 2.1m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 2,
                column: "Score",
                value: 5m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 3,
                column: "Score",
                value: 3.1m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 4,
                column: "Score",
                value: 2m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 5,
                column: "Score",
                value: 2.3m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 6,
                column: "Score",
                value: 3.3m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 7,
                column: "Score",
                value: 1.3m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 8,
                column: "Score",
                value: 3m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 9,
                column: "Score",
                value: 4m);

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "DislikesCount", "UserID" },
                values: new object[] { 1, 1 });

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 3,
                column: "UserID",
                value: 1);

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 4,
                column: "UserID",
                value: 1);

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 5,
                columns: new[] { "DislikesCount", "LikesCount" },
                values: new object[] { 2, 8 });

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 7,
                column: "UserID",
                value: 1);

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 8,
                column: "UserID",
                value: 1);

            migrationBuilder.UpdateData(
                table: "Rating",
                keyColumn: "ID",
                keyValue: 3,
                columns: new[] { "MovieID", "UserID" },
                values: new object[] { 4, 2 });

            migrationBuilder.UpdateData(
                table: "Rating",
                keyColumn: "ID",
                keyValue: 4,
                column: "MovieID",
                value: 2);

            migrationBuilder.UpdateData(
                table: "User",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "Email", "FirstName", "LastName" },
                values: new object[] { "armina.cosic@edu.fit.ba", "Armina", "Čosić" });
        }
    }
}
