using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ZoozyApi.Data.Migrations;

public partial class InitialCreate : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.CreateTable(
            name: "FirebaseSyncLogs",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                PayloadSource = table.Column<string>(type: "nvarchar(128)", maxLength: 128, nullable: false),
                PetsProcessed = table.Column<int>(type: "int", nullable: false),
                ProvidersProcessed = table.Column<int>(type: "int", nullable: false),
                RequestsProcessed = table.Column<int>(type: "int", nullable: false),
                SyncedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                Notes = table.Column<string>(type: "nvarchar(max)", nullable: true)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_FirebaseSyncLogs", x => x.Id);
            });

        migrationBuilder.CreateTable(
            name: "PetProfiles",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                FirebaseId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                Name = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: false),
                Species = table.Column<string>(type: "nvarchar(128)", maxLength: 128, nullable: false),
                Breed = table.Column<string>(type: "nvarchar(128)", maxLength: 128, nullable: true),
                Age = table.Column<int>(type: "int", nullable: true),
                VaccinationStatus = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                HealthNotes = table.Column<string>(type: "nvarchar(max)", nullable: true),
                OwnerName = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: false),
                OwnerContact = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: false),
                CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_PetProfiles", x => x.Id);
            });

        migrationBuilder.CreateTable(
            name: "ServiceProviders",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                FirebaseId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                Name = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: false),
                ServiceType = table.Column<string>(type: "nvarchar(128)", maxLength: 128, nullable: false),
                Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                Location = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: false),
                ContactInfo = table.Column<string>(type: "nvarchar(256)", maxLength: 256, nullable: true),
                Rating = table.Column<decimal>(type: "decimal(3,2)", precision: 3, scale: 2, nullable: true),
                OffersLiveTracking = table.Column<bool>(type: "bit", nullable: false),
                OffersVideoCall = table.Column<bool>(type: "bit", nullable: false),
                CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_ServiceProviders", x => x.Id);
            });

        migrationBuilder.CreateTable(
            name: "ServiceRequests",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                FirebaseId = table.Column<string>(type: "nvarchar(450)", nullable: false),
                PetProfileId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                ServiceProviderId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                ServiceType = table.Column<string>(type: "nvarchar(128)", maxLength: 128, nullable: false),
                PreferredDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                Status = table.Column<string>(type: "nvarchar(64)", maxLength: 64, nullable: false),
                Notes = table.Column<string>(type: "nvarchar(max)", nullable: true),
                LiveTrackingUrl = table.Column<string>(type: "nvarchar(512)", maxLength: 512, nullable: true),
                VideoCallEnabled = table.Column<bool>(type: "bit", nullable: false),
                CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false),
                UpdatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_ServiceRequests", x => x.Id);
                table.ForeignKey(
                    name: "FK_ServiceRequests_PetProfiles_PetProfileId",
                    column: x => x.PetProfileId,
                    principalTable: "PetProfiles",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Restrict);
                table.ForeignKey(
                    name: "FK_ServiceRequests_ServiceProviders_ServiceProviderId",
                    column: x => x.ServiceProviderId,
                    principalTable: "ServiceProviders",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Restrict);
            });

        migrationBuilder.CreateIndex(
            name: "IX_PetProfiles_FirebaseId",
            table: "PetProfiles",
            column: "FirebaseId",
            unique: true);

        migrationBuilder.CreateIndex(
            name: "IX_ServiceProviders_FirebaseId",
            table: "ServiceProviders",
            column: "FirebaseId",
            unique: true);

        migrationBuilder.CreateIndex(
            name: "IX_ServiceRequests_FirebaseId",
            table: "ServiceRequests",
            column: "FirebaseId",
            unique: true);

        migrationBuilder.CreateIndex(
            name: "IX_ServiceRequests_PetProfileId",
            table: "ServiceRequests",
            column: "PetProfileId");

        migrationBuilder.CreateIndex(
            name: "IX_ServiceRequests_ServiceProviderId",
            table: "ServiceRequests",
            column: "ServiceProviderId");
    }

    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable(
            name: "FirebaseSyncLogs");

        migrationBuilder.DropTable(
            name: "ServiceRequests");

        migrationBuilder.DropTable(
            name: "PetProfiles");

        migrationBuilder.DropTable(
            name: "ServiceProviders");
    }
}

