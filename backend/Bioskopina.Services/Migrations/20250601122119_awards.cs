using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    public partial class awards : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {

            migrationBuilder.AlterColumn<string>(
           name: "Awards",
           table: "Bioskopina",
           type: "nvarchar(max)",
           nullable: true,  
           oldClrType: typeof(string),
           oldType: "nvarchar(max)");

        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {

            migrationBuilder.AlterColumn<string>(
           name: "Awards",
           table: "Bioskopina",
           type: "nvarchar(max)",
           nullable: false,  // <-- revert to NOT nullable here
           oldClrType: typeof(string),
           oldType: "nvarchar(max)",
           oldNullable: true);

        }
    }
}
