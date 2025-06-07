using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    public partial class cascadegenre : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Genre_Bioskopina_Movies",
                table: "Genre_Movies");

            migrationBuilder.AddForeignKey(
                name: "FK_Genre_Bioskopina_Movies",
                table: "Genre_Movies",
                column: "MovieID",
                principalTable: "Bioskopina",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Genre_Bioskopina_Movies",
                table: "Genre_Movies");

            migrationBuilder.AddForeignKey(
                name: "FK_Genre_Bioskopina_Movies",
                table: "Genre_Movies",
                column: "MovieID",
                principalTable: "Bioskopina",
                principalColumn: "ID",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
