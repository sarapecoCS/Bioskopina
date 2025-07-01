using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class morebioskopinawatchlists : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 1,
                column: "DateStarted",
                value: new DateTime(2025, 7, 10, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus", "WatchlistID" },
                values: new object[] { null, new DateTime(2025, 7, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "Watching", 1 });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 3,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus", "WatchlistID" },
                values: new object[] { new DateTime(2025, 6, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 5, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "Completed", 1 });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 4,
                columns: new[] { "DateFinished", "DateStarted", "MovieID", "WatchStatus", "WatchlistID" },
                values: new object[] { new DateTime(2025, 4, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 15, 0, 0, 0, 0, DateTimeKind.Unspecified), 2, "Completed", 2 });

            migrationBuilder.InsertData(
                table: "Bioskopina_Watchlist",
                columns: new[] { "ID", "DateFinished", "DateStarted", "MovieID", "WatchStatus", "WatchlistID" },
                values: new object[,]
                {
                    { 5, null, new DateTime(2025, 5, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 4, "On Hold", 2 },
                    { 6, null, new DateTime(2025, 5, 1, 0, 0, 0, 0, DateTimeKind.Unspecified), 5, "On Hold", 2 },
                    { 7, null, new DateTime(2025, 6, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), 1, "Dropped", 3 },
                    { 8, null, new DateTime(2025, 6, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), 6, "Dropped", 3 },
                    { 9, null, new DateTime(2025, 7, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), 3, "Watching", 4 },
                    { 10, null, new DateTime(2025, 7, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), 5, "Watching", 4 },
                    { 11, null, new DateTime(2025, 7, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), 7, "Watching", 4 },
                    { 12, null, new DateTime(2025, 7, 5, 0, 0, 0, 0, DateTimeKind.Unspecified), 8, "Watching", 4 }
                });

            migrationBuilder.InsertData(
                table: "Watchlist",
                columns: new[] { "ID", "DateAdded", "UserID" },
                values: new object[] { 5, new DateTime(2025, 6, 12, 22, 28, 47, 882, DateTimeKind.Local).AddTicks(3188), 5 });

            migrationBuilder.InsertData(
                table: "Bioskopina_Watchlist",
                columns: new[] { "ID", "DateFinished", "DateStarted", "MovieID", "WatchStatus", "WatchlistID" },
                values: new object[,]
                {
                    { 13, new DateTime(2025, 4, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6933), new DateTime(2025, 3, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6788), 1, "Completed", 5 },
                    { 14, new DateTime(2025, 4, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6945), new DateTime(2025, 3, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6942), 2, "Completed", 5 },
                    { 15, new DateTime(2025, 4, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6951), new DateTime(2025, 3, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6948), 3, "Completed", 5 },
                    { 16, new DateTime(2025, 4, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6957), new DateTime(2025, 3, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6954), 4, "Completed", 5 },
                    { 17, new DateTime(2025, 4, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6962), new DateTime(2025, 3, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6960), 5, "Completed", 5 },
                    { 18, new DateTime(2025, 4, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6968), new DateTime(2025, 3, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6966), 6, "Completed", 5 },
                    { 19, new DateTime(2025, 4, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6974), new DateTime(2025, 3, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6971), 7, "Completed", 5 },
                    { 20, new DateTime(2025, 4, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6980), new DateTime(2025, 3, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6977), 8, "Completed", 5 },
                    { 21, new DateTime(2025, 4, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6985), new DateTime(2025, 3, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6983), 9, "Completed", 5 }
                });
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "Watchlist",
                keyColumn: "ID",
                keyValue: 5);

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 1,
                column: "DateStarted",
                value: new DateTime(2025, 7, 11, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 2,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus", "WatchlistID" },
                values: new object[] { new DateTime(2025, 4, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 10, 0, 0, 0, 0, DateTimeKind.Unspecified), "Completed", 3 });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 3,
                columns: new[] { "DateFinished", "DateStarted", "WatchStatus", "WatchlistID" },
                values: new object[] { null, new DateTime(2025, 7, 11, 0, 0, 0, 0, DateTimeKind.Unspecified), "On Hold", 2 });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 4,
                columns: new[] { "DateFinished", "DateStarted", "MovieID", "WatchStatus", "WatchlistID" },
                values: new object[] { null, new DateTime(2025, 7, 11, 0, 0, 0, 0, DateTimeKind.Unspecified), 4, "Dropped", 4 });
        }
    }
}
