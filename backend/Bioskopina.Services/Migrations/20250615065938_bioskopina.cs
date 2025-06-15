using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class bioskopina : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_PreferredGenre_Genre",
                table: "PreferredGenre");

            migrationBuilder.AddForeignKey(
                name: "FK_PreferredGenre_Genre",
                table: "PreferredGenre",
                column: "GenreID",
                principalTable: "Genre",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_PreferredGenre_Genre",
                table: "PreferredGenre");

            migrationBuilder.AddForeignKey(
                name: "FK_PreferredGenre_Genre",
                table: "PreferredGenre",
                column: "GenreID",
                principalTable: "Genre",
                principalColumn: "ID",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
