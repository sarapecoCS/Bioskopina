using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace Bioskopina.Services.Migrations
{
    /// <inheritdoc />
    public partial class seedingwatchlists : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 13,
                columns: new[] { "DateFinished", "DateStarted" },
                values: new object[] { new DateTime(2025, 4, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 12, 0, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 14,
                columns: new[] { "DateFinished", "DateStarted" },
                values: new object[] { new DateTime(2025, 4, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 12, 0, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 15,
                columns: new[] { "DateFinished", "DateStarted" },
                values: new object[] { new DateTime(2025, 4, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 12, 0, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 16,
                columns: new[] { "DateFinished", "DateStarted" },
                values: new object[] { new DateTime(2025, 4, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 12, 0, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 17,
                columns: new[] { "DateFinished", "DateStarted" },
                values: new object[] { new DateTime(2025, 4, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 12, 0, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 18,
                columns: new[] { "DateFinished", "DateStarted" },
                values: new object[] { new DateTime(2025, 4, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 12, 0, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 19,
                columns: new[] { "DateFinished", "DateStarted" },
                values: new object[] { new DateTime(2025, 4, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 12, 0, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 20,
                columns: new[] { "DateFinished", "DateStarted" },
                values: new object[] { new DateTime(2025, 4, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 12, 0, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 21,
                columns: new[] { "DateFinished", "DateStarted" },
                values: new object[] { new DateTime(2025, 4, 12, 0, 0, 0, 0, DateTimeKind.Unspecified), new DateTime(2025, 3, 12, 0, 0, 0, 0, DateTimeKind.Unspecified) });

            migrationBuilder.UpdateData(
                table: "Watchlist",
                keyColumn: "ID",
                keyValue: 5,
                column: "DateAdded",
                value: new DateTime(2025, 6, 12, 22, 31, 3, 323, DateTimeKind.Local).AddTicks(4645));
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 13,
                columns: new[] { "DateFinished", "DateStarted" },
                values: new object[] { new DateTime(2025, 4, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6933), new DateTime(2025, 3, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6788) });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 14,
                columns: new[] { "DateFinished", "DateStarted" },
                values: new object[] { new DateTime(2025, 4, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6945), new DateTime(2025, 3, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6942) });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 15,
                columns: new[] { "DateFinished", "DateStarted" },
                values: new object[] { new DateTime(2025, 4, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6951), new DateTime(2025, 3, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6948) });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 16,
                columns: new[] { "DateFinished", "DateStarted" },
                values: new object[] { new DateTime(2025, 4, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6957), new DateTime(2025, 3, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6954) });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 17,
                columns: new[] { "DateFinished", "DateStarted" },
                values: new object[] { new DateTime(2025, 4, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6962), new DateTime(2025, 3, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6960) });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 18,
                columns: new[] { "DateFinished", "DateStarted" },
                values: new object[] { new DateTime(2025, 4, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6968), new DateTime(2025, 3, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6966) });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 19,
                columns: new[] { "DateFinished", "DateStarted" },
                values: new object[] { new DateTime(2025, 4, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6974), new DateTime(2025, 3, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6971) });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 20,
                columns: new[] { "DateFinished", "DateStarted" },
                values: new object[] { new DateTime(2025, 4, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6980), new DateTime(2025, 3, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6977) });

            migrationBuilder.UpdateData(
                table: "Bioskopina_Watchlist",
                keyColumn: "ID",
                keyValue: 21,
                columns: new[] { "DateFinished", "DateStarted" },
                values: new object[] { new DateTime(2025, 4, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6985), new DateTime(2025, 3, 12, 22, 28, 47, 888, DateTimeKind.Local).AddTicks(6983) });

            migrationBuilder.UpdateData(
                table: "Watchlist",
                keyColumn: "ID",
                keyValue: 5,
                column: "DateAdded",
                value: new DateTime(2025, 6, 12, 22, 28, 47, 882, DateTimeKind.Local).AddTicks(3188));
        }
    }
}
