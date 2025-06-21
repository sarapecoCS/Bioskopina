using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class morelists : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "List",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "DateCreated", "Name", "UserID" },
                values: new object[] { new DateTime(2025, 6, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "Relax", 1 });

            migrationBuilder.InsertData(
                table: "List",
                columns: new[] { "ID", "DateCreated", "Name", "UserID" },
                values: new object[,]
                {
                    { 2, new DateTime(2025, 6, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "Historical", 1 },
                    { 3, new DateTime(2025, 6, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "Artistic Films", 2 },
                    { 4, new DateTime(2025, 6, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "Classic Collection", 3 },
                    { 5, new DateTime(2025, 6, 20, 0, 0, 0, 0, DateTimeKind.Unspecified), "Nihilistic Night", 4 }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "List",
                keyColumn: "ID",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "List",
                keyColumn: "ID",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "List",
                keyColumn: "ID",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "List",
                keyColumn: "ID",
                keyValue: 5);

            migrationBuilder.UpdateData(
                table: "List",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "DateCreated", "Name", "UserID" },
                values: new object[] { new DateTime(2025, 7, 11, 0, 0, 0, 0, DateTimeKind.Unspecified), "Artistic", 2 });
        }
    }
}
