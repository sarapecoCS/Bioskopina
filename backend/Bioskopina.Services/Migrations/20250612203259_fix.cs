using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class fix : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Watchlist",
                keyColumn: "ID",
                keyValue: 5,
                column: "DateAdded",
                value: new DateTime(2025, 6, 12, 22, 32, 58, 400, DateTimeKind.Local).AddTicks(4906));
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Watchlist",
                keyColumn: "ID",
                keyValue: 5,
                column: "DateAdded",
                value: new DateTime(2025, 6, 12, 22, 31, 3, 323, DateTimeKind.Local).AddTicks(4645));
        }
    }
}
