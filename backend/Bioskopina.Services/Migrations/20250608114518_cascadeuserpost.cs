using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class cascadeuserpost : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UserPostAction_Post",
                table: "UserPostAction");

            migrationBuilder.AddForeignKey(
                name: "FK_UserPostAction_Post",
                table: "UserPostAction",
                column: "PostID",
                principalTable: "Post",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UserPostAction_Post",
                table: "UserPostAction");

            migrationBuilder.AddForeignKey(
                name: "FK_UserPostAction_Post",
                table: "UserPostAction",
                column: "PostID",
                principalTable: "Post",
                principalColumn: "ID",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
