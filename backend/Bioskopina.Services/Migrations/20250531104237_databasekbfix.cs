using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    public partial class databasekbfix : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
       name: "Awards",
       table: "Bioskopina",
       type: "nvarchar(max)", // or your database column type
       nullable: true,
       oldClrType: typeof(string),
       oldType: "nvarchar(max)");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
        name: "Awards",
        table: "Bioskopina",
        type: "nvarchar(max)", // or your database column type
        nullable: false,
        defaultValue: "",
        oldClrType: typeof(string),
        oldType: "nvarchar(max)",
        oldNullable: true);
        }
    }
}
