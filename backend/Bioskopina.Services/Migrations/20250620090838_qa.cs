using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class qa : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Q&A",
                keyColumn: "ID",
                keyValue: 4);

            migrationBuilder.UpdateData(
                table: "Q&A",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "Answer", "CategoryID", "Question", "UserID" },
                values: new object[] { "It's in progress, it will be available once it's tested and ready.", 4, "Can we get a forum feature in this app?", 3 });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Q&A",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "Answer", "CategoryID", "Question", "UserID" },
                values: new object[] { "We’re planning to add support for more languages in the near future, so you can expect more subtitle options soon!", 3, "I wish there were more subtitles", 1 });

            migrationBuilder.InsertData(
                table: "Q&A",
                columns: new[] { "ID", "Answer", "CategoryID", "Displayed", "Question", "UserID" },
                values: new object[] { 4, "It's in progress, it will be available once it's tested and ready.", 4, true, "Can we get a forum feature in this app?", 3 });
        }
    }
}
