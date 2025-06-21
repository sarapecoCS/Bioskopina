using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class recommenderfixdelete : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Recommender_Movies",
                table: "Recommender");

            migrationBuilder.AddForeignKey(
                name: "FK_Recommender_Movies",
                table: "Recommender",
                column: "MovieID",
                principalTable: "Bioskopina",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Recommender_Movies",
                table: "Recommender");

            migrationBuilder.AddForeignKey(
                name: "FK_Recommender_Movies",
                table: "Recommender",
                column: "MovieID",
                principalTable: "Bioskopina",
                principalColumn: "ID",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
