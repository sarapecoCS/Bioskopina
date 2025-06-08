using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class postedit : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 1,
                column: "Content",
                value: "Ever seen a movie that challenges everything you thought you knew? Three is one of those films. What do you think about movies that make you think deeply, even if they're a bit hard to grasp at first?");

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 2,
                column: "Content",
                value: "A raw, unsettling journey. The Rats Woke Up dives deep into the complexities of human nature. Have you ever watched a movie that just leaves you thinking for days after? This is one of those.");

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 3,
                column: "Content",
                value: "This one’s a wild ride—part psychological, part political, and entirely bizarre. WR: Mysteries of the Organism is one for those who love films that are as confusing as they are compelling. Thoughts?");

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 4,
                column: "Content",
                value: "Sometimes the most powerful stories are the simplest ones. It Rains in My Village captures life in its purest form. How do you feel about films that focus on the quiet moments?");

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 5,
                column: "Content",
                value: "A haunting meditation on life and death. When I Am Dead and Gone explores what happens when everything we know is gone. What’s your take on films that ask big questions about our existence?");

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 6,
                column: "Content",
                value: "If you’re into thought-provoking cinema with a dark edge, Uzrok smrti ne pominjati might just be your thing. It’s an exploration of history and humanity’s darker sides. What do you think about movies that confront uncomfortable truths?");

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 7,
                column: "Content",
                value: "A classic! I Even Met Happy Gypsies is a poignant look at the lives of those who live on the margins of society. Have you ever seen a film that makes you rethink your perspective on the world?");

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 8,
                column: "Content",
                value: "Early Works is one of those films that packs a punch with its rawness. It's a perfect example of how art can push boundaries. What’s the most daring film you’ve ever seen?");

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 9,
                column: "Content",
                value: "A gripping story of survival and loyalty. The Ambush takes you on a journey you won’t forget. What do you think about war films that focus on the human cost over the action?");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 1,
                column: "Content",
                value: "Three");

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 2,
                column: "Content",
                value: "The Rats Woke Up");

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 3,
                column: "Content",
                value: "WR: Mysteries of the Organism");

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 4,
                column: "Content",
                value: "It Rains in My Village");

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 5,
                column: "Content",
                value: "When I Am Dead and Gone");

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 6,
                column: "Content",
                value: "Uzrok smrti ne pominjati");

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 7,
                column: "Content",
                value: "I Even Met Happy Gypsies");

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 8,
                column: "Content",
                value: "Early Works");

            migrationBuilder.UpdateData(
                table: "Post",
                keyColumn: "ID",
                keyValue: 9,
                column: "Content",
                value: "The Ambush");
        }
    }
}
