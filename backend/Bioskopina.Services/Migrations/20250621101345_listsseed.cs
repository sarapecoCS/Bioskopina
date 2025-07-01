using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class listsseed : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "List",
                keyColumn: "ID",
                keyValue: 1,
                column: "UserID",
                value: 3);

            migrationBuilder.UpdateData(
                table: "List",
                keyColumn: "ID",
                keyValue: 2,
                column: "UserID",
                value: 3);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "List",
                keyColumn: "ID",
                keyValue: 1,
                column: "UserID",
                value: 1);

            migrationBuilder.UpdateData(
                table: "List",
                keyColumn: "ID",
                keyValue: 2,
                column: "UserID",
                value: 1);
        }
    }
}
