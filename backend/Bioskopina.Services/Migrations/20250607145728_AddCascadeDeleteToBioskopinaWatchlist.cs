using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    public partial class AddCascadeDeleteToBioskopinaWatchlist : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Bioskopina_Watchlist_Bioskopina",
                table: "Bioskopina_Watchlist");

            migrationBuilder.AddForeignKey(
                name: "FK_Bioskopina_Watchlist_Bioskopina",
                table: "Bioskopina_Watchlist",
                column: "MovieID",
                principalTable: "Bioskopina",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Bioskopina_Watchlist_Bioskopina",
                table: "Bioskopina_Watchlist");

            migrationBuilder.AddForeignKey(
                name: "FK_Bioskopina_Watchlist_Bioskopina",
                table: "Bioskopina_Watchlist",
                column: "MovieID",
                principalTable: "Bioskopina",
                principalColumn: "ID",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
