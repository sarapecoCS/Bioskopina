using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class cascadecommentfix : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UserCommentAction_Comment",
                table: "UserCommentAction");

            migrationBuilder.AddForeignKey(
                name: "FK_UserCommentAction_Comment",
                table: "UserCommentAction",
                column: "CommentID",
                principalTable: "Comment",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UserCommentAction_Comment",
                table: "UserCommentAction");

            migrationBuilder.AddForeignKey(
                name: "FK_UserCommentAction_Comment",
                table: "UserCommentAction",
                column: "CommentID",
                principalTable: "Comment",
                principalColumn: "ID");
        }
    }
}
