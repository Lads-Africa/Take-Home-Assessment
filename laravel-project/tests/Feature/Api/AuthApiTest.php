<?php

namespace Tests\Feature\Api;

use App\Models\User;
use Tests\TestCase;

class AuthApiTest extends TestCase
{
    /** @test */
    public function admin_can_login_with_valid_credentials()
    {
        $password = 'password123';

        User::factory()->create([
            'email' => 'admin@test.com',
            'role'  => 'admin',
            'password' => bcrypt($password),
        ]);

        $response = $this->postJson('/api/login', [
            'email'    => 'admin@test.com',
            'password' => $password,
        ]);

        $response
            ->assertStatus(200)
            ->assertJsonStructure([
                'user' => ['id', 'name', 'email', 'role'],
            ]);

        $this->assertEquals('admin', $response->json('user.role'));
    }

    /** @test */
    public function login_fails_with_invalid_credentials()
    {
        $password = 'password123';

        User::factory()->create([
            'email' => 'user@test.com',
            'role'  => 'user',
            'password' => bcrypt($password),
        ]);

        $response = $this->postJson('/api/login', [
            'email'    => 'user@test.com',
            'password' => 'wrong-password',
        ]);

        // Adjust to 401 if your API uses 401 instead of 422
        $response->assertStatus(422);
    }

    /** @test */
    public function authenticated_user_can_fetch_own_profile()
    {
        $user = User::factory()->create();

        $this->actingAs($user, 'sanctum');

        $response = $this->getJson('/api/user');

        $response->assertStatus(200)
            ->assertJson([
                'email' => $user->email,
            ]);
    }

    /** @test */
    public function unauthenticated_request_to_user_endpoint_returns_401_json()
    {
        $response = $this->getJson('/api/user');

        $response->assertStatus(401)
            ->assertJson([
                'message' => 'Unauthenticated.',
            ]);
    }
}
