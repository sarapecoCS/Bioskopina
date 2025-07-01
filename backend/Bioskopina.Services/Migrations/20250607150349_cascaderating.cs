using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    public partial class cascaderating : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Rating_Bioskopina",
                table: "Rating");

            migrationBuilder.AddForeignKey(
                name: "FK_Rating_Bioskopina",
                table: "Rating",
                column: "MovieID",
                principalTable: "Bioskopina",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Rating_Bioskopina",
                table: "Rating");

            migrationBuilder.AddForeignKey(
                name: "FK_Rating_Bioskopina",
                table: "Rating",
                column: "MovieID",
                principalTable: "Bioskopina",
                principalColumn: "ID",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
