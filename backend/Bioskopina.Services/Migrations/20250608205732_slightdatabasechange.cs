using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class slightdatabasechange : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Awards",
                table: "Bioskopina");

            migrationBuilder.DropColumn(
                name: "Cast",
                table: "Bioskopina");

            migrationBuilder.DropColumn(
                name: "IMDbRatings",
                table: "Bioskopina");

            migrationBuilder.DropColumn(
                name: "TitleYugo",
                table: "Bioskopina");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Awards",
                table: "Bioskopina",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Cast",
                table: "Bioskopina",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "IMDbRatings",
                table: "Bioskopina",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "TitleYugo",
                table: "Bioskopina",
                type: "nvarchar(200)",
                maxLength: 200,
                nullable: false,
                defaultValue: "");

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "Awards", "Cast", "IMDbRatings", "TitleYugo" },
                values: new object[] { "Nominated for 1 Oscar - 2 wins & 2 nominations total", "", "7.7/10", "Tri" });

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "Awards", "Cast", "IMDbRatings", "TitleYugo" },
                values: new object[] { "4 wins & 1 nomination", "", "7.6/10", "Buđenje pacova" });

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 3,
                columns: new[] { "Awards", "Cast", "IMDbRatings", "TitleYugo" },
                values: new object[] { "4 wins & 1 nomination total", "", "6.7/10", "W. R. – Misterije organizma" });

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 4,
                columns: new[] { "Awards", "Cast", "IMDbRatings", "TitleYugo" },
                values: new object[] { "1 wins & 1 nomination total", "", "7.2/10", "Biće skoro propast sveta" });

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 5,
                columns: new[] { "Awards", "Cast", "IMDbRatings", "TitleYugo" },
                values: new object[] { "4 wins & 2 nomination total", "", "7.9/10", "Kad budem mrtav i beo" });

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 6,
                columns: new[] { "Awards", "Cast", "IMDbRatings", "TitleYugo" },
                values: new object[] { " 0 nomination total", "", "7.0/10", "Uzrok smrti ne pominjati" });

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 7,
                columns: new[] { "Awards", "Cast", "IMDbRatings", "TitleYugo" },
                values: new object[] { "Nominated for 1 Oscar - 7 wins & 6 nominations total", "", "7.6/10--", "Skupljaci perja" });

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 8,
                columns: new[] { "Awards", "Cast", "IMDbRatings", "TitleYugo" },
                values: new object[] { "2 wins in total", "", "7.6/10", "Rani radovi" });

            migrationBuilder.UpdateData(
                table: "Bioskopina",
                keyColumn: "ID",
                keyValue: 9,
                columns: new[] { "Awards", "Cast", "IMDbRatings", "TitleYugo" },
                values: new object[] { "2 wins in total", "", "7.6/10", "Zaseda" });
        }
    }
}
