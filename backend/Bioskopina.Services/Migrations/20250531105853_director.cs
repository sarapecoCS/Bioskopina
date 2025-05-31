using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    public partial class director : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
           name: "Director",
           table: "Bioskopina",
           type: "nvarchar(max)",
           nullable: true,
           oldClrType: typeof(string),
           oldType: "nvarchar(max)",
           oldNullable: false);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
          name: "Director",
          table: "Bioskopina",
          type: "nvarchar(max)",
          nullable: false,
          oldClrType: typeof(string),
          oldType: "nvarchar(max)",
          oldNullable: true);
        }
    }
}
