using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class novo : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 3,
                column: "TitleEN",
                value: "Mysteries of the Organism");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 3,
                column: "TitleEN",
                value: "WR: Mysteries of the Organism");
        }
    }
}
