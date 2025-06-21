using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class watchlistsupgrade : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "DateFinished",
                table: "Bioskopina_Watchlist");

            migrationBuilder.DropColumn(
                name: "DateStarted",
                table: "Bioskopina_Watchlist");

            migrationBuilder.DropColumn(
                name: "WatchStatus",
                table: "Bioskopina_Watchlist");

            migrationBuilder.UpdateData(
                table: "List",
                keyColumn: "ID",
                keyValue: 1,
                column: "Name",
                value: "Artistic");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "DateFinished",
                table: "Bioskopina_Watchlist",
                type: "datetime",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "DateStarted",
                table: "Bioskopina_Watchlist",
                type: "datetime",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "WatchStatus",
                table: "Bioskopina_Watchlist",
                type: "nvarchar(30)",
                maxLength: 30,
                nullable: false,
                defaultValue: "");

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 1,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { null, new DateTime(2025, 7, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "Watching" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { null, new DateTime(2025, 7, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "Watching" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 3,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { new DateTime(2025, 6, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 5, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "Completed" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 4,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { new DateTime(2025, 4, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), "Completed" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 5,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { null, new DateTime(2025, 5, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "On Hold" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 6,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { null, new DateTime(2025, 5, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), "On Hold" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 7,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { null, new DateTime(2025, 6, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "Dropped" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 8,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { null, new DateTime(2025, 6, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "Dropped" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 9,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { null, new DateTime(2025, 7, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "Watching" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 10,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { null, new DateTime(2025, 7, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "Watching" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 11,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { null, new DateTime(2025, 7, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "Watching" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 12,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { null, new DateTime(2025, 7, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), "Watching" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 13,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { new DateTime(2025, 4, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), "Completed" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 14,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { new DateTime(2025, 4, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), "Completed" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 15,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { new DateTime(2025, 4, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), "Completed" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 16,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { new DateTime(2025, 4, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), "Completed" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 17,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { new DateTime(2025, 4, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), "Completed" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 18,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { new DateTime(2025, 4, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), "Completed" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 19,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { new DateTime(2025, 4, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), "Completed" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 20,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { new DateTime(2025, 4, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), "Completed" });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 21,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus" },
                values: new object[] { new DateTime(2025, 4, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), "Completed" });

            migrationBuilder.UpdateData(
                table: "List",
                keyColumn: "ID",
                keyValue: 1,
                column: "Name",
                value: "Favorites");
        }
    }
}
