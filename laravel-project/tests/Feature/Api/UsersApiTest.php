<?php

namespace Tests\Feature\Api;

use App\Models\User;
use Tests\TestCase;

class UsersApiTest extends TestCase
{
    /** @test */
    public function admin_can_list_users()
    {
        $admin = $this->actingAsAdmin();

        User::factory()->count(3)->create();

        $response = $this->getJson('/api/users');

        $response->assertStatus(200)
            ->assertJsonFragment(['email' => $admin->email]);
    }

    /** @test */
    public function normal_user_cannot_list_all_users()
    {
        $this->actingAsUser();

        $response = $this->getJson('/api/users');

        $response->assertStatus(403); // adjust if implementation differs
    }

    /** @test */
    public function admin_can_update_user_with_valid_data()
    {
        $this->actingAsAdmin();

        $user = User::factory()->create();

        $payload = [
            'name'  => 'Updated Name',
            'email' => 'updated@example.com',
            'role'  => 'user',
        ];

        $response = $this->putJson("/api/users/{$user->id}", $payload);

        $response->assertStatus(200)
            ->assertJsonFragment([
                'name'  => 'Updated Name',
                'email' => 'updated@example.com',
            ]);

        $this->assertDatabaseHas('users', [
            'id'    => $user->id,
            'email' => 'updated@example.com',
        ]);
    }

    /** @test */
    public function updating_user_with_invalid_email_returns_validation_error()
    {
        $this->actingAsAdmin();

        $user = User::factory()->create();

        $payload = [
            'name'  => 'User Name',
            'email' => 'not-an-email',
            'role'  => 'user',
        ];

        $response = $this->putJson("/api/users/{$user->id}", $payload);

        $response->assertStatus(422)
            ->assertJsonValidationErrors(['email']);
    }

    /** @test */
    public function normal_user_cannot_update_admin()
    {
        $admin = $this->createAdminUser();
        $this->actingAsUser();

        $payload = [
            'name'  => 'Hacked Admin',
            'email' => $admin->email,
            'role'  => 'admin',
        ];

        $response = $this->putJson("/api/users/{$admin->id}", $payload);

        $response->assertStatus(403);
    }

    /** @test */
    public function admin_can_delete_a_user()
    {
        $this->actingAsAdmin();

        $user = User::factory()->create();

        $response = $this->deleteJson("/api/users/{$user->id}");

        // Adjust message to your actual implementation if needed
        $response->assertStatus(200);

        $this->assertDatabaseMissing('users', ['id' => $user->id]);
    }
}
