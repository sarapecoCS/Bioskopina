using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class contextchange : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Bioskopina_List_List",
                table: "BioskopinaList");

            migrationBuilder.AddForeignKey(
                name: "FK_Bioskopina_List_List",
                table: "BioskopinaList",
                column: "ListID",
                principalTable: "List",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Bioskopina_List_List",
                table: "BioskopinaList");

            migrationBuilder.AddForeignKey(
                name: "FK_Bioskopina_List_List",
                table: "BioskopinaList",
                column: "ListID",
                principalTable: "List",
                principalColumn: "ID",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
