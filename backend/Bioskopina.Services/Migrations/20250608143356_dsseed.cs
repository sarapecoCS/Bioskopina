using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class dsseed : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Q&A_Q&ACategory",
                table: "Q&A");

            migrationBuilder.AddForeignKey(
                name: "FK_Q&A_Q&ACategory",
                table: "Q&A",
                column: "CategoryID",
                principalTable: "Q&ACategory",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Q&A_Q&ACategory",
                table: "Q&A");

            migrationBuilder.AddForeignKey(
                name: "FK_Q&A_Q&ACategory",
                table: "Q&A",
                column: "CategoryID",
                principalTable: "Q&ACategory",
                principalColumn: "ID",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
