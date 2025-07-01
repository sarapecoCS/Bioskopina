using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class dstri : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
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
        }
    }
}
