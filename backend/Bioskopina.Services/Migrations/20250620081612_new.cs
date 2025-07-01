using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class @new : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 2,
                column: "LikesCount",
                value: 0);

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 3,
                column: "LikesCount",
                value: 2);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 2,
                column: "LikesCount",
                value: 3);

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 3,
                column: "LikesCount",
                value: 7);
        }
    }
}
