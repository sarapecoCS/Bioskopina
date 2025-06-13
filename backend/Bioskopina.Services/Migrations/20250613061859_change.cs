using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class change : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Watchlist",
                keyColumn: "ID",
                keyValue: 3,
                column: "UserID",
                value: 1);

            migrationBuilder.UpdateData(
                table: "Watchlist",
                keyColumn: "ID",
                keyValue: 4,
                column: "UserID",
                value: 1);

            migrationBuilder.UpdateData(
                table: "Watchlist",
                keyColumn: "ID",
                keyValue: 5,
                column: "UserID",
                value: 1);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Watchlist",
                keyColumn: "ID",
                keyValue: 3,
                column: "UserID",
                value: 3);

            migrationBuilder.UpdateData(
                table: "Watchlist",
                keyColumn: "ID",
                keyValue: 4,
                column: "UserID",
                value: 4);

            migrationBuilder.UpdateData(
                table: "Watchlist",
                keyColumn: "ID",
                keyValue: 5,
                column: "UserID",
                value: 5);
        }
    }
}
