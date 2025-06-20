using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class donation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Donation",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "DateDonated", "UserID" },
                values: new object[] { new DateTime(2025, 9, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), 5 });

            migrationBuilder.UpdateData(
                table: "Donation",
                keyColumn: "ID",
                keyValue: 3,
                column: "UserID",
                value: 3);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Donation",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "DateDonated", "UserID" },
                values: new object[] { new DateTime(2025, 1, 11, 0, 0, 0, 0, DateTimeKind.Unspecified), 2 });

            migrationBuilder.UpdateData(
                table: "Donation",
                keyColumn: "ID",
                keyValue: 3,
                column: "UserID",
                value: 2);
        }
    }
}
