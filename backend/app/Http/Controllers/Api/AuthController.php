<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Tymon\JWTAuth\Exceptions\JWTException;

class AuthController extends Controller
{
    public function __constructor()
    {
//        $this->middleware('auth:api', ['except' => ['login']]);
    }

    public function register()
    {
        $email = request('email');
        $password = request('password');
        $user = new User;
        $user->fill(request()->all());
        $user->password=bcrypt($password);
        $user->save();

        $token = $this->publishToken($email, $password);
        return $this->responseWithToken($token);
    }

    /**
     * @return JsonResponse
     */
    public function login()
    {
        $email = request('email');
        $password = request('password');
        if (! $token = $this->publishToken($email, $password)) {
            return response()->json([
                 'error' => 'Unauthorized'
            ],401);
        }
        return $this->responseWithToken($token);
    }

    /**
     *
     * @return JsonResponse
     */
    public function me()
    {
        return response()->json(auth()->user());
    }

    /**
     * @return JsonResponse
     */
    public function logout()
    {
        auth()->logout();
        return response()->json([
            'message' => 'Successfully logged out'
        ]);
    }

    /**
     * @return JsonResponse
     */
    public function refresh()
    {
        try {
            return $this->responseWithToken(auth()->refresh());
        } catch (JWTException $e) {
            return response()->json([
                'error' => 'Unauthorized'
            ], 401);
        }
    }

    private function publishToken(string $email, string $password)
    {
        return auth()->attempt(['email' => $email, 'password' => $password]);
    }

    /**
     * @param string $token
     * @return JsonResponse
     */
    private function responseWithToken(string $token)
    {
        return response()->json([
            'access_token' => $token,
            'token_type' => 'bearer',
            'expires_in' => auth()->factory()->getTTL() * 60
        ]);
    }
}
