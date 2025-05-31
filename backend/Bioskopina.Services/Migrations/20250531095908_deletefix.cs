using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    public partial class deletefix : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 4,
                column: "Score",
                value: 2m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 6,
                columns: new[] { "TitleEN", "TitleYugo" },
                values: new object[] { "Do Not Mention the Cause of Death", "Uzrok smrti ne pominjati" });

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 8,
                column: "Score",
                value: 3m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 9,
                column: "Score",
                value: 4m);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 4,
                column: "Score",
                value: 0m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 6,
                columns: new[] { "TitleEN", "TitleYugo" },
                values: new object[] { "Uzrok smrti ne pominjati", "Do Not Mention the Cause of Death" });

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 8,
                column: "Score",
                value: 0m);

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 9,
                column: "Score",
                value: 0m);
        }
    }
}
