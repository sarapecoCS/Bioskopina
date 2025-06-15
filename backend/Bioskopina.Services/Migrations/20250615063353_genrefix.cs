using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class genrefix : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Genre_Movie_Genre",
                table: "Genre_Movies");

            migrationBuilder.AddForeignKey(
                name: "FK_Genre_Movie_Genre",
                table: "Genre_Movies",
                column: "GenreID",
                principalTable: "Genre",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Genre_Movie_Genre",
                table: "Genre_Movies");

            migrationBuilder.AddForeignKey(
                name: "FK_Genre_Movie_Genre",
                table: "Genre_Movies",
                column: "GenreID",
                principalTable: "Genre",
                principalColumn: "ID",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
