using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class listcascade : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Bioskopina_List_;ovie",
                table: "BioskopinaList");

            migrationBuilder.AddForeignKey(
                name: "FK_Bioskopina_List_;ovie",
                table: "BioskopinaList",
                column: "MovieID",
                principalTable: "Bioskopina",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Bioskopina_List_;ovie",
                table: "BioskopinaList");

            migrationBuilder.AddForeignKey(
                name: "FK_Bioskopina_List_;ovie",
                table: "BioskopinaList",
                column: "MovieID",
                principalTable: "Bioskopina",
                principalColumn: "ID",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
